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
    track = make_label(frame: [[20, 40 * @count + 10], [280, 30]], text: @file_name, font_size: 20, color: UIColor.darkGrayColor)
    track.file_url = @file_url

    @tracks << track

    @tracks.last.when_tapped do |r|
      play(r.view.file_url)
    end

    self.view.addSubview(track)

    @count += 1

  end

  def play(file_url)
    puts "play"

    @player = AVAudioPlayer.alloc.initWithContentsOfURL(file_url, error:nil)
    @player.play

  end

end