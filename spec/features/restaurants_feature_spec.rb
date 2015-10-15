require 'rails_helper'

feature 'restaurants' do

  let(:user){ build :user }
  let(:user2){ build :user2 }

  context 'no restaurants haven been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        sign_up(user)
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
     visit '/restaurants'
     click_link 'KFC'
     expect(page).to have_content 'KFC'
     expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do

    scenario "users can edit restaurants they created" do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
      click_link 'Edit McDonalds'
      fill_in 'Name', with: 'Maccas'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Maccas'
      expect(current_path).to eq '/restaurants'
    end

    scenario "users can only edit restaurants they've created" do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      sign_up(user2)
      expect(page).not_to have_content 'Edit McDonalds'
    end

  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "users can only delete restaurants which they've created" do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      sign_up(user2)
      expect(page).not_to have_content 'Delete McDonalds'
    end

  end









end
