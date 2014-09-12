//
//  GameViewController.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 8/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "GameViewController.h"
#import "CollectionViewLabelCell.h"
#import "GameReviewViewController.h"

@interface GameViewController () <UICollectionViewDataSource> { //Agrego Delegado para manejo de la collecction {

GameReviewViewController * gameReview;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *featureCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *dayReleasedLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation GameViewController {
    NSDictionary* _game;
}

//Metodo Get: game
-(NSDictionary*) game{
    return _game;
    
}

//Metodo Set: game
-(void)setGame:(NSDictionary *)game{
    _game = game;
    [self updateControlsWithGameData];
}

//Metodo que actualiza la informacion de pantalla
-(void) updateControlsWithGameData {
    //Seteo Titulo, Imagen, Fecha Lanzamiento, Descripcion y Puntuacion
    self.navigationBar.topItem.title = self.game[@"title"];
    
    NSString* imageName = self.game[@"image"];
    //UIImage* image = [UIImage imageNamed:imageName];
    UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
    self.imageView.image = image;

    self.dayReleasedLabel.text = self.game[@"release"];
    
    self.scoreLabel.text = self.game[@"score"];
    
    NSArray* descriptions = self.game[@"descriptions"];
    self.descriptionTextView.text = [descriptions componentsJoinedByString:@"\n\n"];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    gameReview = [segue destinationViewController];
    gameReview.gameTitle = self.navigationBar.topItem.title;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Configuro Background.
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background-LowerLayer-1"]];
    backgroundImageView.frame = CGRectMake(0, 0, 320, 568);
    backgroundImageView.alpha = 0.5f;
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
    
    //Configuro el Collection View.
    [self.featureCollectionView registerClass:[CollectionViewLabelCell class] forCellWithReuseIdentifier:@"cell"];
    self.featureCollectionView.dataSource = self;
    self.featureCollectionView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout* flowLayout = (UICollectionViewFlowLayout*)self.featureCollectionView.collectionViewLayout;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(150, 20);
   self.descriptionGameTextView.backgroundColor = [UIColor clearColor];
    [self updateControlsWithGameData];
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

#pragma - UICollectionViewDataSource methods
//Este metodo devuelve la cantidad de objestos que hay en la coleccion.
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray* features = _game[@"features"];
    return features.count;
}

//Setea el nombre de la celda de la coleccion
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewLabelCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSArray* features = _game[@"features"];
    cell.title.text = features[indexPath.row];
    return cell;
}
@end
