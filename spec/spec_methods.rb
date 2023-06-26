def build_test_mpeg
  file_data = IO.read('spec/audio_input.mp3')
  tempfile = Tempfile.new('file_name')
  tempfile.binmode && tempfile.write(file_data) && tempfile.rewind
  ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, type: 'audio/mpeg', filename: 'original_file_name.mp3')
end

def build_test_mov
  file_data = IO.read('spec/audio_input.mp3')
  tempfile = Tempfile.new('file_name')
  tempfile.binmode && tempfile.write(file_data) && tempfile.rewind
  ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, type: 'video/quicktime', filename: 'original_file_name.mov')
end
