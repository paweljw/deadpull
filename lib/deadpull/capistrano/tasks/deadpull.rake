# frozen_string_literal: true

# rubocop:disable BlockLength
namespace :deadpull do
  def deadpull_environment
    environment = fetch(:deadpull_environment) || fetch(:stage)
    Deadpull::Values::Environment.concretize(environment)
  end

  def deadpull_path
    fetch(:deadpull_path)
  end

  def deadpull_config
    config = deadpull_path ? { path: deadpull_path } : {}
    Deadpull::Values::Configuration.concretize(config)
  end

  def deadpull_roles
    fetch(:deadpull_roles)
  end

  desc 'Fetch files locally and upload them to server'
  task :upload do
    Dir.mktmpdir do |dir|
      Deadpull::Commands::Pull.call(dir, deadpull_config, deadpull_environment)
      on roles(deadpull_roles) do
        within release_path do
          Dir[Pathname.new(dir).join('**', '*')].each do |local_path|
            upload! local_path, Deadpull::Values::RootRelativePath.concretize(dir, local_path)
          end
        end
      end
    end
  end

  after('deploy:updating', 'deadpull:upload') if Rake::Task.task_defined?('deploy:updating')
end
# rubocop:enable BlockLength

namespace :load do
  task :defaults do
    set :deadpull_roles, :app
  end
end
