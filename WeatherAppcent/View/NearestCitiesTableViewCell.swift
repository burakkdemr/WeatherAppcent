//
//  NearestCitiesTableViewCell.swift
//  WeatherAppcent
//
//  Created by burak on 7.10.2020.
//

import UIKit

class NearestCitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblNearCity: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCityListCell(near:LocationModel){
        self.lblNearCity.text = near.title
    }
}
