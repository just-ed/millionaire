require 'rails_helper'

RSpec.feature 'User views alien profile', type: :feature do
  let(:user) { FactoryGirl.create(:user, name: 'Вадик') }
  let(:another_user) { FactoryGirl.create(:user, name: 'Миша') }

  let!(:games) do
    [
      FactoryGirl.create(
        :game,
        id: 1,
        user: another_user,
        prize: 8_000,
        current_level: 7,
        created_at: Time.parse('2019-03-05 12:00'),
        finished_at: Time.parse('2019-03-05 12:15'),
        is_failed: false
      ),
      FactoryGirl.create(
        :game,
        id: 2,
        user: another_user,
        prize: 1_000,
        current_level: 8,
        created_at: Time.parse('2019-03-05 12:30'),
        finished_at: Time.parse('2019-03-05 12:45'),
        is_failed: true
      )
    ]
  end

  before(:each) do
    login_as user
  end

  scenario 'successfully' do
    visit '/'

    click_link 'Миша'

    expect(page).to have_current_path "/users/#{another_user.id}"

    expect(page).to have_content'Миша'
    expect(page).not_to have_content'Сменить имя и пароль'

    expect(page).to have_content'1' # номер игры
    expect(page).to have_content'деньги' # статус
    expect(page).to have_content'05 марта, 12:00' # дата
    expect(page).to have_content'7' # уровень вопроса
    expect(page).to have_content'8 000 ₽' # выигрыш

    expect(page).to have_content'2' # номер игры
    expect(page).to have_content'проигрыш' # статус
    expect(page).to have_content'05 марта, 12:30' # дата
    expect(page).to have_content'8' # уровень вопроса
    expect(page).to have_content'1 000 ₽' # выигрыш
  end
end
