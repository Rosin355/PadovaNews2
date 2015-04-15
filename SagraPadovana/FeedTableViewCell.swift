//
//  FeedTableViewCell.swift
//  PadovaNews
//
//  Created by Romesh Singhabahu on 12/04/15.
//  Copyright (c) 2015 Romesh Singhabahu. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

  
    
    @IBOutlet weak var ItemTitleLabel: UILabel!
    @IBOutlet weak var ItemAuthorLabel: UILabel!
    @IBOutlet weak var ItemImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code for change cell background colors
        backgroundColor = UIColor.blackColor()
        ItemAuthorLabel.textColor = UIColor.whiteColor()
        ItemAuthorLabel.highlightedTextColor = ItemAuthorLabel.textColor
        ItemTitleLabel.textColor = UIColor(hue: 1.0, saturation: 2.0, brightness: 1.0, alpha: 1.0)
        ItemTitleLabel.highlightedTextColor = ItemTitleLabel.textColor
        
        let selectionView = UIView (frame: CGRect.zeroRect)
        selectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        selectedBackgroundView = selectionView

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        

    }
    
 
    

}
