# def generate_silent_audio(duration)
#   # Set the desired file name.
#   file_name = "audio_input.mp3"
#   # set the ffmpeg command to generate silent mp3 binary
#   cmd = "ffmpeg -f lavfi -i anullsrc=r=44100:cl=mono -t #{duration} -q:a 9 -acodec libmp3lame -f mp3 pipe:1"
#   output, error, status = Open3.capture3(cmd)
#   if status.success?
#     puts "[Silent audio file generated successfully]"
#     # Write the silent audio data to a file with the specified name.
#     File.open(file_name, "wb") do |file|
#       file.write(output)
#     end
#   else
#     puts "[Error generating silent audio file: #{error}]"
#     return nil
#   end
# end
