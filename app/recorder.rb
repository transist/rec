# class Recorder
  
#   def initialize
#     @state = AQRecorderState.new
#   end

#   def inspect
#     @state.mDataFormat
#   end


# end

# class AQRecorderState

#   attr_reader :mDataFormat

#   def initialize
#     kNumberBuffers = 3
#     @mDataFormat = AudioStreamBasicDescription.new
#     @mQueue = AudioQueueRef.new
#     @mBuffers = Array.new(kNumberBuffers){|el| AudioQueueBufferRef.new}
#     @mAudioFile = AudioFileID.new
#   end

# end
