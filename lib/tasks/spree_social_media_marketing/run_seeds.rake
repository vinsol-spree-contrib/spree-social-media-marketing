namespace :spree_social_media_marketing do
  desc 'Run seeds from spree_social_media_marketing'
  task run_seeds: :environment do
    seed_file = File.join(File.expand_path("../../../../db", __FILE__), "seeds.rb")
    load(seed_file) if File.exist?(seed_file)
  end
end