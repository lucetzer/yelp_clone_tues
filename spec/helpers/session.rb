module SessionHelpers

  def sign_up(user)
    visit '/users/sign_up'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'
  end

  # def leave_review(thoughts, rating)
  #   visit '/restaurants'
  #
  #   click_link 'Sign up'
  #   fill_in 'Email', with: 'test@test.com'
  #   fill_in 'Password', with: 'testtest'
  #   fill_in 'Password confirmation', with: 'testtest'
  #   click_button 'Sign up'
  #
  #   click_link 'Add a restaurant'
  #   fill_in 'Name', with: 'KFC'
  #   click_button 'Create Restaurant'
  #   click_link 'Review KFC'
  #   fill_in 'Thoughts', with: thoughts
  #   select rating, from: 'Rating'
  #   click_button 'Leave Review'
  # end


end
