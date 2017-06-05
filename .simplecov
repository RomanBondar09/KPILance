SimpleCov.start 'rails' do
  add_filter do |source_file|
    source_file.lines.count < 2
  end
end
# SimpleCov.minimum_coverage 90
# SimpleCov.maximum_coverage_drop 0
