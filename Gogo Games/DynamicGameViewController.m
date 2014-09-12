//
//  DynamicGameViewController.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 8/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "DynamicGameViewController.h"
#import "AppDelegate.h"
#import "GameViewController.h"

@interface DynamicGameViewController () <UICollisionBehaviorDelegate> // Delegado que me permite definir como jugar con la gravedad de las vistas

@end

@implementation DynamicGameViewController {
    // Esta variable se utilizara para crear las vistas de los juegos de acuerdo a la plantilla
    NSMutableArray* _views;
    
    // Variables para el Manejo de la Gravedad y Animacion
    UIGravityBehavior* _gravity;
    UIDynamicAnimator* _animator;
    CGPoint _previousTouchPoint;
    BOOL _draggingView;
    
    // Variables para el Dock
    UISnapBehavior* _snap;
    BOOL _viewDocked;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Este metodo es para obtener la informacion de los juegos desde el AppDelegate.
-(NSArray*)games{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    return appDelegate.games;
}

// Este Metodo crea las vistas de cada juego de forma dinamica.
-(UIView*)addGameAtOffset:(CGFloat)offset forGame:(NSDictionary*)game {
    
    CGRect frameForView = CGRectOffset(self.view.bounds, 0.0, self.view.bounds.size.height - offset);
    
    // Creo la Vista Controlador del juego.
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GameViewController* viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"gameVC"];
    
    // Seteo Frame y los Datos.
    UIView* view = viewController.view;
    view.frame = frameForView;
    viewController.game = game;
    
    // Agrego a la Vista como hijo en la Vista Principal.
    [self addChildViewController:viewController];
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    
    // Agrego el reconocedor de gestos.
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  
    [viewController.view addGestureRecognizer:pan];
    
    // Agrego Colision a la vista.
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:collision];
    
    // Configuro el limite inferior donde se apoyan las views.
    float boundary = view.frame.origin.y + view.frame.size.height+1;
    CGPoint boundaryStart = CGPointMake(0.0, boundary);
    CGPoint boundaryEnd = CGPointMake(self.view.bounds.size.width, boundary);
    [collision addBoundaryWithIdentifier:@1
                               fromPoint:boundaryStart
                                 toPoint:boundaryEnd];
    
    // Configuro el limite superior para detectar y realizar el Dock.
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(self.view.bounds.size.width, 0.0);
    [collision addBoundaryWithIdentifier:@2
                               fromPoint:boundaryStart
                                 toPoint:boundaryEnd];
    
    //Configuro el limite izquierdo para que no se salga de pantalla.
    boundaryStart = CGPointMake(0.0, 0.0);
    boundaryEnd = CGPointMake(0.0, self.view.bounds.size.height);
    [collision addBoundaryWithIdentifier:@3
                               fromPoint:boundaryStart
                                 toPoint:boundaryEnd];
    
    //Configuro el limite derecho para que no se salga de pantalla.
    boundaryStart = CGPointMake(self.view.bounds.size.width, 0.0);
    boundaryEnd = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    [collision addBoundaryWithIdentifier:@4
                               fromPoint:boundaryStart
                                 toPoint:boundaryEnd];
    
    collision.collisionDelegate = self;
    
    // Aplico la gravedad a al vista.
    [_gravity addItem:view];
    
    // Agrego Comportamiento a la vista y se lo paso al animador.
    UIDynamicItemBehavior* itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[view]];
    [_animator addBehavior:itemBehavior];
    
    return view;
}

// Este metodo maneja los gestos touch.
- (void)handlePan:(UIPanGestureRecognizer*)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    UIView* draggedView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // Verifica si se hace PAN desde la parte superior.
        UIView* draggedView = gesture.view;
        CGPoint dragStartLocation = [gesture locationInView:draggedView];
        
        if (dragStartLocation.y < 200.0f) {
            _draggingView = YES;
            _previousTouchPoint = touchPoint;
        }
        
    } else if (gesture.state == UIGestureRecognizerStateChanged && _draggingView) {
        
        // Manejo del arrastre.
        float yOffset = _previousTouchPoint.y - touchPoint.y;
        //gesture.view.center = CGPointMake(draggedView.center.x,
        //                                  draggedView.center.y - yOffset);
        gesture.view.center = CGPointMake(160,
                                          draggedView.center.y - yOffset);
        _previousTouchPoint = touchPoint;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded && _draggingView) {
        // Termina el Gesture (Suelto).
        [self tryDockView:draggedView];
        [self addVelocityToView:draggedView fromGesture:gesture];
        [_animator updateItemUsingCurrentState:draggedView];
        _draggingView = NO;
    }
}

// Este metodo le agrega velocidad a la vista de acuerdo al gesto Pan Vertical que se efectue.
- (void)addVelocityToView:(UIView *)view fromGesture:(UIPanGestureRecognizer *)gesture {
    // Convierte la Velocidad del Pan en la Velocidad del objeto (Vista).
    CGPoint vel = [gesture velocityInView:self.view];
    vel.x = 0;
    UIDynamicItemBehavior* behaviour = [self itemBehaviourForView:view];
    [behaviour addLinearVelocity:vel forItem:view];
}

// Este metodo es que el que Dockea la vista si se encuentra en el area de Dockeo.
- (void)tryDockView:(UIView *)view {
    
    BOOL viewHasReachedDockLocation = view.frame.origin.y < 50.0;
    if (viewHasReachedDockLocation) {
        if (!_viewDocked) {
            _snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:self.view.center];
            [_animator addBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:0.0];
            _viewDocked = YES;
        }
    } else {
        if (_viewDocked) {
            [_animator removeBehavior:_snap];
            [self setAlphaWhenViewDocked:view alpha:1.0];
            _viewDocked = NO;
        }
    }
}

// Este metodo pone todas las vistas invisibles si se dockea una vista, sino las vuelve a poner visibles.
- (void)setAlphaWhenViewDocked:(UIView*)view alpha:(CGFloat)alpha {
    for (UIView* aView in _views) {
        if (aView != view) {
            aView.alpha = alpha;
        }
    }
}

// Este metodo detecta si se esta en el area de Dock y procede a Dockear la vista.
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    if ([@2 isEqual:identifier]) {
        UIView* view = (UIView*) item;
        [self tryDockView:view];
    }
}

// Este metodo detecta a que vista se le esta aplicando el compartamiento.
- (UIDynamicItemBehavior*) itemBehaviourForView:(UIView*)view {
    for (UIDynamicItemBehavior* behaviour in _animator.behaviors) {
        if (behaviour.class ==[UIDynamicItemBehavior class] && [behaviour.items firstObject] == view) {
            return behaviour;
        }
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Seteo Imagen de Fondo.
    //UIImageView* backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-LowerLayer.png"]];
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Background-LowerLayer-1.png"]]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 568);
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    //Seteo Nombre Aplicacion
    UILabel * titleApplication = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 320, 50)];
    titleApplication.text = @"GoGo Games";
    //[titleApplication setFont:[UIFont systemFontOfSize:20]];
    [titleApplication setFont:[UIFont boldSystemFontOfSize:50]];
    titleApplication.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleApplication];
   
    //Seteo Nombre Aplicacion
    UILabel * subTitleApplication = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, 320, 50)];
    subTitleApplication.text = @"Reviews";
    //[subTitleApplication setFont:[UIFont systemFontOfSize:20]];
    [subTitleApplication setFont:[UIFont boldSystemFontOfSize:40]];
    subTitleApplication.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:subTitleApplication];
    
    // Seteo Logo.
    //UIImageView* header = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Logo.png"]];
    UIImageView* header = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"Logo-1.jpg"]]];
    header.frame = CGRectMake(0, 0, 128, 128);
    header.center = CGPointMake(245, 245);
    [header setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:header];
 
    // Defino el Animador que manejara la gravedad de las vistas.
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Defino la gravedad de las vistas.
    _gravity = [[UIGravityBehavior alloc] init];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 4.0f;
    
    //Seteo/Genero Vistas Juegos.
    _views =[NSMutableArray new];
    CGFloat offset = 250.0f;
    for (NSDictionary* game in [self games]) {
        [_views addObject:[self addGameAtOffset:offset forGame:game]];
        offset -=50.0f;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
