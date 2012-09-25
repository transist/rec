class RecorderViewController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.backgroundColor = UIColor.grayColor
  end

  def viewDidLoad
    @label_rec = make_label(frame: [[10, 60], [300, 80]], text: 'Rec', font_size: 34, color: UIColor.redColor)
    @label_stop = make_label(frame: [[10, 200], [300, 80]], text: 'Stop', font_size: 34, color: UIColor.orangeColor, hidden: true)
    @label_play = make_label(frame: [[10, 340], [300, 80]], text: 'Play', font_size: 34, color: UIColor.yellowColor, hidden: true)

    self.view.setUserInteractionEnabled(true)

    @label_rec.when_tapped do
      rec
    end

    @label_stop.when_tapped do
      stop
    end

    @label_play.when_tapped do
      play
    end

    self.view.addSubview(@label_rec)
    self.view.addSubview(@label_stop)
    self.view.addSubview(@label_play)

    @state = :stopped
  end

  def make_label(options)
    label = UILabel.alloc.initWithFrame(options[:frame])
    label.text = options[:text] || 'Label Text'
    label.font = UIFont.boldSystemFontOfSize(options[:font_size]) || 30
    label.textColor = options[:color] || UIColor.redColor
    label.textAlignment = options[:alignment] || UITextAlignmentCenter
    label.setHidden(options[:hidden] || false)
    label
  end

  def rec
    puts "rec!!!"

    @label_stop.setHidden(false)
    @label_rec.text = 'Recording...'

    @file_url = NSURL.fileURLWithPath(File.join(NSHomeDirectory(), 'Documents', "#{Time.now.strftime('%Y%m%d%H%M%S')}.aac"))
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
    @label_rec.text = 'Rec'
    @label_stop.setHidden(true)
    @label_play.setHidden(false)

    @state = :stopped
  end

  def play
    puts "play"

    @player = AVAudioPlayer.alloc.initWithContentsOfURL(@file_url, error:nil)
    @player.play

  end

end