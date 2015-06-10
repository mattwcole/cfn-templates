require 'aws-sdk-resources'
require 'aws-sdk-core'

task default: [:generate_templates, :validate_templates, :upload_templates]

desc 'Generate templates using lono'
task :generate_templates do
  puts 'Generating templates...'
  system('lono generate')
  puts 'Template generation complete'
end

desc 'Validate generated templates with the AWS SDK'
task :validate_templates do
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
task :upload_templates do
  s3 = Aws::S3::Resource.new
  bucket = s3.bucket('cf-templates-iyt00u3m1bdw-eu-west-1')
  
  template_paths = Dir['output/*.json']
  existing_templates = bucket.objects.map(&:key)

  puts 'Uploading templates...'
  template_paths.each do |template_path|
    template = File.basename(template_path)

    if existing_templates.include?(template)
      puts "  WARNING: Template #{template} already exists in S3, skipping"
    else
      bucket.object(template).upload_file(template_path)
    end
  end
  puts 'Template uploading complete'
end
