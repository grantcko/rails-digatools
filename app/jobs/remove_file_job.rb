class RemoveFileJob < ApplicationJob
  def perform(output_path)
    puts "\n\n\n\n\nremoving file: #{output_path}\n\n\n\n\n"
    `rm public/equalized_audio/#{output_path}`
  end
end
