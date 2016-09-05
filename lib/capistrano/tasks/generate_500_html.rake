task :generate_500_html do
  on roles(:web) do |host|
    public_500_html = File.join(release_path, "public/500.html")
    execute :curl, "-k", "https://#{host.hostname}/500", "> #{public_500_html}"
  end
end
after "deploy:published", :generate_500_html
