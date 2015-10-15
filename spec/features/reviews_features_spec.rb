require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'KFC'}
  let(:user){ build :user }
  let(:user2){ build :user2 }

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     sign_up(user)
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'
     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario "users can only leave one review per restaurant" do
    visit '/restaurants'
    sign_up(user)
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(page).not_to have_content 'Review KFC'
  end

  scenario "users can only delete their own reviews" do
    visit '/restaurants'
    sign_up(user)
    click_link 'Review KFC'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Delete Review for KFC'
    expect(page).not_to have_content 'Review for KFC'
    expect(current_path).to eq '/restaurants'
  end


  # scenario "users can only delete their own reviews" do
  #   visit '/restaurants'
  #   sign_up(user)
  #   click_link 'Review KFC'
  #   fill_in "Thoughts", with: "so so"
  #   select '3', from: 'Rating'
  #   click_button 'Leave Review'
  #   click_link 'Sign out'
  #   sign_up(user2)
  #   click_link 'Review KFC'
  #   fill_in "Thoughts", with: "so so"
  #   select '3', from: 'Rating'
  #   click_button 'Leave Review'
  #   expect(page).to have_content 'You have already reviewed this restaurant'
  #   expect(current_path).to eq '/restaurants'
  # end

end
