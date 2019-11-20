# frozen_string_literal: true

Rails.application.eager_load!

Dir.glob(Rails.root.join('db/seeds/**/*.yml')).each do |f|
  basename = Pathname.new(f).relative_path_from(Pathname.new(Rails.root.join('db/seeds'))).to_s
  type = basename.gsub('.yml', '').singularize.classify.constantize
  begin
    data = YAML.load_file(f)
    created = 0
    skipped = 0
    data.each do |rd|
      obj = type.create rd
      if obj.errors.any?
        skipped += 1
      else
        created += 1
      end
    end
    puts "#{type}: Created #{created}, skipped #{skipped}"
  rescue StandardError => e
    puts "Got error #{e}. Continuing..."
  end
end
