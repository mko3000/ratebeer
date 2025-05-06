require 'English'
require "erb"
LITESTREAM_CONFIG = ENV["LITESTREAM_CONFIG"] || Rails.root.join("tmp/litestream.yml").to_s

LITESTREAM_TEMPLATE = <<~LITESTREAM_YAML.freeze
  # This is the configuration file for litestream.
  #
  # For more details, see: https://litestream.io/reference/config/
  #
  dbs:
  <% for db in @dbs -%>
    - path: <%= db %>
      replicas:
        - type: s3
          endpoint: $AWS_ENDPOINT_URL_S3
          bucket: $BUCKET_NAME
          path: storage/<%= File.basename(db) %>
          access-key-id: $AWS_ACCESS_KEY_ID
          secret-access-key: $AWS_SECRET_ACCESS_KEY
  <% end -%>
LITESTREAM_YAML

namespace :litestream do
  task prepare: "db:load_config" do
    require "erubi"

    @dbs =
      ActiveRecord::Base
      .configurations
      .configs_for(env_name: "production", include_hidden: true)
      .select { |config| ["sqlite3", "litedb"].include? config.adapter }
      .map(&:database)

    erb = ERB.new(LITESTREAM_TEMPLATE, trim_mode: "-")
    result = erb.result(binding)

    unless File.exist?(LITESTREAM_CONFIG) && File.read(LITESTREAM_CONFIG) == result
      File.write(LITESTREAM_CONFIG, result)
    end

    @dbs.each do |db|
      next if File.exist?(db) || !ENV["BUCKET_NAME"]

      system "litestream restore -config #{LITESTREAM_CONFIG} -if-replica-exists #{db}"
      exit $CHILD_STATUS.exitstatus unless $CHILD_STATUS.exitstatus == 0
    end
  end

  task :run do
    require "shellwords"

    exec(*%w[bundle exec litestream replicate -config],
         LITESTREAM_CONFIG, "-exec", Shellwords.join(ARGV[1..]))
  end
end

namespace :db do
  task prepare: "litestream:prepare"
end
