require_relative '../request_spec_helper'

feature 'Users' do
  let(:user) { create(:user) }

  scenario 'can sign-up for an account' do
    visit new_user_registration_path

    page.should have_content('Sign Up')

    fill_in 'First name',    :with => 'Charles'
    fill_in 'Last name',     :with => 'Gerald'
    fill_in 'Email address', :with => 'george@curiouskids.org'

    fill_in 'Password',              :with => 'testing'
    fill_in 'Password confirmation', :with => 'testing'

    check 'I agree to the Terms and Conditions'

    click_on 'Sign up'

    page.should have_content('A message with a confirmation link has been sent to your email address.')
  end

  scenario 'can sign-in from the sign-up form' do
    visit new_user_registration_path

    fill_in 'user_session[email]',    :with => user.email
    fill_in 'user_session[password]', :with => 'change-this'

    click_on 'Log in'
    page.should have_link('My Account')
  end

  describe 'who are unconfirmed' do
    let(:unconfirmed_user) { create(:user, :unconfirmed) }

    scenario 'cannot sign-in' do
      visit new_user_session_path

      fill_in 'user_session[email]',    :with => user.email
      fill_in 'user_session[password]', :with => 'wrong'

      click_on 'Log in'

      page.should have_content('Invalid email or password.')
    end

    scenario 'can confirm their account' do
      visit user_confirmation_path(:confirmation_token => unconfirmed_user.confirmation_token)

      page.should have_content('Welcome to Givegoods')
    end

    scenario 'can resend confirmations instructions' do
      visit new_user_confirmation_path

      page.should have_content('Resend confirmation')

      fill_in 'Email address', :with => unconfirmed_user.email
      click_button 'Resend confirmation'

      page.should have_content('You will receive an email with instructions about how to confirm your account in a few minutes.')
    end

    # Users are explicitly confirmed after resetting their password
    scenario 'can reset their password from the sign-in form' do
      visit new_user_session_path

      click_on 'Forgot your password?'

      page.should have_content('Forgot your password?')
      fill_in "Email address", :with => unconfirmed_user.email
      click_on 'Send password reset instructions'

      page.should have_content('You will receive an email with instructions about how to reset your password in a few minutes.')

      # the password token gets set after previous post
      unconfirmed_user.reload
      visit edit_user_password_path(:reset_password_token => unconfirmed_user.reset_password_token)

      page.should have_content('Change your password')
      fill_in 'New password', :with => 'hoodyhoo'
      fill_in 'Confirm new password', :with => 'hoodyhoo'

      click_on 'Change my password'

      page.should have_content('Welcome to Givegoods')
    end
  end

  def login_user
    visit new_user_session_path

    fill_in 'user_session[email]',    :with => user.email
    fill_in 'user_session[password]', :with => 'change-this'

    click_on 'Log in'
    page.should have_link('My Account')
  end

  describe 'who are confirmed' do
    before do
      login_user
    end

    scenario 'can update their account details' do
      click_on 'My Account'

      page.should have_content('Account Settings')

      fill_in 'First name',       :with => 'Ricky'
      fill_in 'Last name',        :with => 'Smitts'
      fill_in 'Email address',    :with => 'ricky@smitts.com'
      fill_in 'Current password', :with => 'change-this'

      click_on 'Update'
      
      page.should have_content('You updated your account successfully.')
    end

    scenario 'can update their account password' do
      click_on 'My Account'

      page.should have_content('Account Settings')

      fill_in 'Current password',      :with => 'change-this'
      fill_in 'Password',              :with => 'doctor'
      fill_in 'Password confirmation', :with => 'doctor'

      click_on 'Update'
      
      page.should have_content('You updated your account successfully.')
    end

    describe 'without a role' do
      before do
        page.should have_content('Welcome to Givegoods')
      end

      scenario 'can choose a charity role after sign-in' do
        page.find('h4', :text => /I am a charity/).click
        page.should have_content('Create your charity profile')
      end

      scenario 'can choose a merchant role after sign-in' do
        page.find('h4', :text => /I am a merchant/).click
        page.should have_content('Create your merchant profile')
      end
    end
  end
end
