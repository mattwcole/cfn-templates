require 'aws-sdk-resources'
require 'aws-sdk-core'
require 'dotenv'

Dotenv.load

task default: [:generate, :validate, :upload]

desc 'Generate templates using lono'
task :generate do
  puts 'Generating templates...'
  system('lono generate')
  puts 'Template generation complete'
end

desc 'Validate generated templates with the AWS SDK'
task :validate do
  cloud_formation = Aws::CloudFormation::Client.new

  puts 'Validating templates...'
  errors = Array.new
  Dir['output/*.json'].each do |template_path|
    begin
      cloud_formation.validate_template(template_body: File.read(template_path))
    rescue Aws::CloudFormation::Errors::ValidationError => error
      errors.push("Template #{File.basename(template_path)} failed validation: #{error.message}")
    end
  end

  if errors.any?
    raise errors.join("\n")
  else
    puts 'Template validation complete'
  end
end

desc 'Upload generated templates to S3'
task :upload do
  s3 = Aws::S3::Resource.new
  bucket = s3.bucket(ENV['AWS_TEMPLATES_BUCKET'])
  template_paths = Dir['output/*.json']

  puts 'Uploading templates...'
  template_paths.each do |template_path|
    template = File.basename(template_path)

    bucket.object(template).upload_file(template_path)
  end
  puts 'Template uploading complete'
end
