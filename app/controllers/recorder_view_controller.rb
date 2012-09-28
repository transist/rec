class RecorderViewController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.backgroundColor = UIColor.scrollViewTexturedBackgroundColor
  end

  def viewDidLoad
    @button = UIButton.alloc.initWithFrame([[20, 400], [280, 40]])
    @button.setTitle("Rec", forState:UIControlStateNormal)
    @button.setTitle("Recording", forState:UIControlStateHighlighted)
    @button.setTitleColor(UIColor.darkGrayColor, forState:UIControlStateNormal)
    @button.backgroundColor = UIColor.colorWithWhite(1.0, alpha:0.7)
    @button.makeGlossy

    @button.when(UIControlEventTouchDown) do      
      rec
    end
 
    @button.when(UIControlEventTouchUpInside) do
      stop
    end

    self.view.addSubview(@button)

    @tracks = []
  end

  def make_label(options)
    label = TrackView.alloc.initWithFrame(options[:frame])
    label.text = options[:text] || 'Label Text'
    label.font = UIFont.boldSystemFontOfSize(options[:font_size]) || 30
    label.textColor = options[:color] || UIColor.redColor
    label.textAlignment = options[:alignment] || UITextAlignmentCenter
    label.setHidden(options[:hidden] || false)
    label.layer.cornerRadius = options[:corner_radius] || 0
    label
  end

  def rec
    puts "rec!!!"
    @file_name = "#{Time.now.strftime('%Y%m%d%H%M%S')}.aac"
    @file_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', @file_name))

    settings = {"AVFormatIDKey" => KAudioFormatMPEG4AAC}
    errorPointer = Pointer.new(:object)
    @recorder = AVAudioRecorder.alloc.initWithURL(@file_url, settings:settings, error:errorPointer)

    puts "*" * 80
    puts errorPointer[0].localizedDescription if errorPointer && errorPointer[0]

    @recorder.record 

    puts "recorded!!"

  end

  def stop
    puts "stop!!!"

    @recorder.stop if @recorder

    @count ||= 0
    track = make_label(frame: [[20, 40 * @count + 10], [280, 30]], text: @file_name, font_size: 20, color: UIColor.darkGrayColor, corner_radius: 10.0)
    track.file_url = @file_url

    @tracks << track

    @tracks.last.when_tapped do |r|
      play(r.view)
    end

    @tracks.last.when_pressed do |r|
      puts "yooooo"
      r.view.removeFromSuperview
    end

    UIView.animateWithDuration(0.5, 
      animations: lambda{
        self.view.addSubview(track)    
      })

    @count += 1

  end

  def play(track)
    puts "play"

    file_url = track.file_url

    @player = AVAudioPlayer.alloc.initWithContentsOfURL(file_url, error:nil)
    @player.delegate = self
    @current_track = track
    @old_track_name = @current_track.text
    @current_track.text = 'Playing...'
    @player.play

  end

  def audioPlayerDidFinishPlaying(player, successfully:flag)
    @current_track.text = @old_track_name
  end

end