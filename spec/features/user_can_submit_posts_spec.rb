# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Timeline', type: :feature do
  scenario 'Can submit posts and view posts, date, time and username' do
    sign_up
    new_post
    expect(page).to have_content('Hello, world!')
    expect(page).to have_content(User.all.first.id) #'cats@cats.com'
    expect(page).to have_content(Time.now.strftime('%m/%d/%Y, %H:%M'))
  end

  scenario 'Cannot submit posts with messages over 500 characters' do
    sign_up

    @long_text =  'i' * 501
    @short_text = 'i' * 500
    visit '/posts'
    click_link 'New post'
    fill_in 'Message', with: @long_text
    click_button 'Submit'
    expect(page).to have_content(@short_text)
    expect(page).to have_content(User.all.first.id) #'cats@cats.com'
    expect(page).to have_content(Time.now.strftime('%m/%d/%Y, %H:%M'))
  end
end
