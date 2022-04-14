RSpec.configure do |config|
  config.before(:each, type: :system) do
    # 実行時ブラウザ非表示
    driven_by(:selenium_chrome_headless)
  end
end
