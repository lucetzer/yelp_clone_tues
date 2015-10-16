require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}
  let(:user){ build :user }
  let(:user2){ build :user2 }

  before(:each) do
    visit '/restaurants'
    sign_up(user)
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'allows users to leave a review using a form' do
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content 'so so'
  end

  scenario "users can only leave one review per restaurant" do
    expect(page).not_to have_content 'Review KFC'
  end

  scenario "users can delete their own reviews" do
    click_link 'Delete Review for KFC'
    expect(page).not_to have_content 'so so'
  end

  scenario "users cannot delete someone else's review" do
    click_link 'Sign out'
    sign_up(user2)
    expect(page).not_to have_content 'Delete Review for KFC'
  end

end

feature 'ratings' do

  before {Restaurant.create name: 'KFC'}
  let(:user){ build :user }
  let(:user2){ build :user2 }

  before(:each) do
    visit '/restaurants'
    sign_up(user)
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    sign_up(user2)
    click_link 'Review KFC'
    fill_in "Thoughts", with: "Great"
    select '5', from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'displays an average rating for all reviews' do
    # leave_review('So so', '3')
    # leave_review('Great', '5')
    expect(page).to have_content('Average rating: 4')
  end

end
