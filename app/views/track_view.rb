class TrackView < UIView
  attr_accessor :file_url

  def self.make_track(options)
    track = TrackView.alloc.initWithFrame(options[:frame])
    track.text = options[:text] || 'Track Text'
    track.font = UIFont.boldSystemFontOfSize(options[:font_size]) || 30
    track.textColor = options[:color] || UIColor.redColor
    track.textAlignment = options[:alignment] || UITextAlignmentCenter
    track.setHidden(options[:hidden] || false)
    track.layer.cornerRadius = options[:corner_radius] || 0
    track.file_url = options[:file_url]
    track
  end
end