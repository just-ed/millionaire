require 'rails_helper'

RSpec.feature 'User views alien profile', type: :feature do
  let(:user) { FactoryGirl.create(:user, name: 'Вадик') }
  let(:another_user) { FactoryGirl.create(:user, name: 'Миша') }

  let!(:games) do
    [
      FactoryGirl.create(
        :game,
        user: another_user,
        prize: 8_000,
        current_level: 7,
        created_at: Time.parse('2019-03-05 12:00'),
        finished_at: Time.parse('2019-03-05 12:15'),
        is_failed: false
      ),
      FactoryGirl.create(
        :game,
        user: another_user,
        prize: 1_000,
        current_level: 8,
        created_at: Time.parse('2019-03-05 12:30'),
        finished_at: Time.parse('2019-03-05 12:45'),
        is_failed: true
      )
    ]
  end

  before(:each) { login_as user }

  scenario 'successfully' do
    visit '/'

    click_link 'Миша'

    expect(page).to have_current_path "/users/#{another_user.id}"

    expect(page).to have_content 'Миша'
    expect(page).not_to have_content 'Сменить имя и пароль'

    expect(page).to have_selector"#game-#{games.first.id}"

    within "#game-#{games.first.id}" do
      expect(page).to have_content'деньги'
      expect(page).to have_content'05 марта, 12:00'
      expect(page).to have_content'7'
      expect(page).to have_content'8 000 ₽'
    end

    expect(page).to have_selector"#game-#{games[1].id}"

    within "#game-#{games[1].id}" do
      expect(page).to have_content 'проигрыш'
      expect(page).to have_content '05 марта, 12:30'
      expect(page).to have_content '8'
      expect(page).to have_content '1 000 ₽'
    end
  end
end
