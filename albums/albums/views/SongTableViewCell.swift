//
//  SongTableViewCell.swift
//  albums
//
//  Created by Jeff Kang on 10/18/20.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
    var song: Song? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SongTableViewCellDelegate?

    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    
    @IBAction func addSongAction(_ sender: UIButton) {
        
        guard let title = songTitleTextField.text, !title.isEmpty,
              let duration = durationTextField.text, !duration.isEmpty else { return }
        
        delegate?.addSong(title: title, duration: duration)
        
    }
    
    private func updateViews() {
        guard let song = song else { return }
        songTitleTextField.text = song.title
        durationTextField.text = song.duration
        addSongButton.isHidden = true
    }
    
    override func prepareForReuse() {
        songTitleTextField.text = ""
        durationTextField.text = ""
        addSongButton.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol SongTableViewCellDelegate: class {
    
    func addSong(title: String, duration: String)
    
}
