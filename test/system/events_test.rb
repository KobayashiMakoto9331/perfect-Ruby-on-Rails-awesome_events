require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase

  setup do
    sign_in_as(FactoryBot.create(:user))
  end

  test "/event/:id ページを表示" do
    event = FactoryBot.create(:event)
    visit event_path(event)
    assert_selector "h1", text: event.name
  end

  test "/event/new ページでフォームで記入して登録" do
    visit new_event_path
    assert_selector "h1", text: 'イベント作成'

    fill_in "名前", with: "test_name"
    fill_in "場所", with: "test_place"
    fill_in "内容", with: "test_content"

    start_at = Time.current
    end_at = start_at + 3.hour

    start_at_fild = "event_start_at"
    select start_at.strftime("%Y"), from: "#{start_at_fild}_1i" #年
    select I18n.l(start_at, format: '%B'), from: "#{start_at_fild}_2i" #月
    select start_at.strftime("%-d"), from: "#{start_at_fild}_3i" #日
    select start_at.strftime("%H"), from: "#{start_at_fild}_4i" #時
    select start_at.strftime("%M"), from: "#{start_at_fild}_5i" #分

    end_at_fild = "event_end_at"
    select end_at.strftime("%Y"), from: "#{end_at_fild}_1i" #年
    select I18n.l(end_at, format: '%B'), from: "#{start_at_fild}_2i" #月
    select end_at.strftime("%-d"), from: "#{end_at_fild}_3i" #日
    select end_at.strftime("%H"), from: "#{end_at_fild}_4i" #時
    select end_at.strftime("%M"), from: "#{end_at_fild}_5i" #分

    click_on "登録する"
    assert_selector "div.alert", text: "作成しました"
  end

  test "/event/:id ページを表示して削除ボタンを押す" do
    event = FactoryBot.create(:event, owner: current_user)
    visit event_path(event)
    assert_difference("Event.count", -1) do
      accept_confirm do
        click_on "イベントを削除する"
      end
      assert_selector "div.alert", text: "削除しました"
    end
  end

end
