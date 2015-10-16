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

    # scenario 'correct restaurant image is displayed for the restaurant ' do
    #   visit '/restaurants'
    #   sign_up(user)
    #   click_link 'Add a restaurant'
    #   fill_in 'Name', with: 'Pancake King'
    #   click_button 'Choose File'
    #   attach_file "pancakes", './assets/pancakes.png'
    #   click_button 'Create Restaurant'
    #   expect(page).to have_content 'Pancake King'
    #   page.should have_css('img', text: "pancakes.jpg")
    #   expect(current_path).to eq '/restaurants'
    # end

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

  context 'editing and deleting restaurants' do

    before(:each) do
      visit '/restaurants'
      sign_up(user)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'McDonalds'
      click_button 'Create Restaurant'
    end

    scenario "users can edit restaurants they created" do
      click_link 'Edit McDonalds'
      fill_in 'Name', with: 'Maccas'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Maccas'
      expect(current_path).to eq '/restaurants'
    end

    scenario "users can only edit restaurants they've created" do
      click_link 'Sign out'
      sign_up(user2)
      expect(page).not_to have_content 'Edit McDonalds'
    end

    scenario 'removes a restaurant when a user clicks a delete link' do
      click_link 'Delete McDonalds'
      expect(page).not_to have_content 'McDonalds'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "users can only delete restaurants which they've created" do
      click_link 'Sign out'
      sign_up(user2)
      expect(page).not_to have_content 'Delete McDonalds'
    end

  end

end
