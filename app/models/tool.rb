
class Tool < ApplicationRecord
  EQ_DIRECTIONS = %i[highpass radio lowpass vocal]
  belongs_to :user

  validates :name, presence: true
  validates :internals, presence: true

  internals = ['custom', 'color_picker', 'auto_equalizer', 'prompt_generator']

  validates :internals, inclusion: { in: internals, message: "is not a valid item" }, allow_nil: true
  validate :internal_array?

  def internal_array?
    unless internals.is_a?(Array)
      errors.add(:my_column, "must be an array")
      return false
    end
    true
  end

  def self.valid_direction?(direction)
    # raise
    return false if EQ_DIRECTIONS.exclude?(direction)

    return true
  end

  def self.valid_audio_input?(file)
    file_ext = File.extname(File.basename(file))
    valid_extensions = %w[.wav .aac .mp3 .m4a]
    # raise
    return false if valid_extensions.exclude?(file_ext)

    return true
  end

  def self.equalize(audio_input, direction) # Get audio file and apply eq changes based on direction
    if audio_input.is_a?(String) # define input file name for ffmpeg transcoding
      file_name = audio_input
    else
      file_name = audio_input.path
    end

    # define output name
    og_filename = File.basename(audio_input)
    file_base_name = File.basename(audio_input.original_filename, ".*")
    file_ext = File.extname(og_filename)
    random_id = "#{rand.to_s[2..6]}"
    output_file_name = "#{file_base_name}_output_#{random_id}#{file_ext}"

    # return error if invalid direction or audio_input
    raise ArgumentError.new("Invalid audio_input") unless Tool.valid_audio_input?(audio_input)
    raise ArgumentError.new("Invalid direction") unless Tool.valid_direction?(direction)

    # apply eq changes based on direction
    case direction
    when EQ_DIRECTIONS[0] # highpass
      # apply HIGHPASS changes with ffmpeg cli (both channels, at 0Hz, 3000Hz wide, -96dB )
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=0 w=3000 g=-96 t=2|c1 f=0 w=3000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[1] # radio
      # apply RADIO changes with ffmpeg cli (both channels, at Hz, Hz wide, -dB )
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=0 w=2500 g=-96 t=2|c1 f=0 w=2500 g=-96 t=2|c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[2] # lowpass
      # apply lowpass changes
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=15000 w=16000 g=-96 t=2|c1 f=15000 w=16000 g=-96 t=2' public/equalized_audio/#{output_file_name}")
    when EQ_DIRECTIONS[3] # vocal
      # apply vocal changes
      system("ffmpeg -i #{file_name} -af 'anequalizer=c0 f=3000 w=2000 g=10 t=2|c1 f=3000 w=2000 g=10 t=2' public/equalized_audio/#{output_file_name}")
    end

    return output_file_name
  end
end
