//
//  CollectionViewLabelCell.m
//  Gogo Games
//
//  Created by Agustin Jose Mazzeo on 8/09/14.
//  Copyright (c) 2014 Smallville. All rights reserved.
//

#import "CollectionViewLabelCell.h"
#import <QuartzCore/QuartzCore.h> //Con esto se puede redondear
@implementation CollectionViewLabelCell
{
    UILabel* _title;
}

//Metodo Get: Title
-(UILabel*)title {
    return _title;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //Agrego el label a la celda
        _title = [[UILabel alloc]initWithFrame:CGRectInset(self.bounds, 3.0, 3.0)];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_title];
        
        //Ahora lo redondeo
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.layer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
