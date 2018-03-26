# test/system/games_test.rb
require "application_system_test_case"

class GamesTest < ApplicationSystemTestCase
  test "Going to /new gives us a new random grid to play with" do
    visit new_url
    assert test: "New game"
    assert_selector "li", count: 10
  end

  test "non-english word yields negative response" do
    visit new_url
    fill_in "word", with: "s"
    click_on "Submit"

    assert_text "Sorry but s does not seem to be a valid english word..."
  end

  test "not in the grid word yields negative response" do
    visit new_url
    fill_in "word", with: "ssdfsdf"
    click_on "Submit"

    assert_text "Sorry but ssdfsdf can't be built out of"
  end

  test "correct word yields positive response" do
    visit new_url
    fill_in "word", with: "so"
    click_on "Submit"

    assert_text "Congratulations! 'so' is a valid English word!"
  end
end
