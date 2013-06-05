require 'zip/zip'
require 'pony'

require 'simplecov'
SimpleCov.start

puts "Ruby Version: #{RUBY_VERSION}"

SimpleCov.minimum_coverage 100

SimpleCov.at_exit do
  SimpleCov.result.format!
  if SimpleCov.result.covered_percent < SimpleCov.minimum_coverage
    fail_msg = "#{'%.2f' % SimpleCov.result.covered_percent}% test coverage?? Really??!!"
    STDERR.puts "\033[0;31m#{fail_msg}\033[0m\nWrite more tests"

    archive = "test-coverage.zip"

    Zip::ZipFile.open(archive, 'w') do |zipfile|
      Dir["coverage/**/**"].reject{ |f| f == archive}.each do |file|
        zipfile.add(file.sub('coverage/',''),file)
      end
    end

    Pony.mail({
      :to => "alexey.pismenskiy@octanner.com",
      :from => "admin@octanner.com",
      :subject => "Coverage for latest CircleCI build",
      :body => "Unzip the attachment and load test-coverage/index.html to read.",
      :attachments => {"test-coverage.zip" => File.read(archive)}
    })

    exit 1
  end
end

require 'rack/test'
require 'rack-auth-oc_tanner'
require 'ostruct'
RSpec.configure do |config|
  config.order = "random"
end
