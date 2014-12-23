require "spec_helper"

describe TimeSeries do
  let(:user) { create(:user) }

  before(:each) do
    Timecop.freeze(DateTime.new(2014, 1, 4))
    create(:entry, hours: 6, date: DateTime.new(2014, 1, 1), user: user)
    create(:entry, hours: 2, date: DateTime.new(2014, 1, 1), user: user)
    create(:entry, hours: 5, date: DateTime.new(2014, 1, 3), user: user)
  end

  describe '#serialize' do
    it "returns the sum of hours for each day" do
      time_series = TimeSeries.weekly(user)
      expect(time_series.serialize).to eq({
        labels: [
          '29/12',
          '30/12',
          '31/12',
          '01/01',
          '02/01',
          '03/01',
          '04/01',
        ],

        datasets: [{
          data: [0, 0, 0, 8, 0, 5, 0]
        }]
      })
    end
  end

  describe "#days" do
    it "returns the number of days in the series" do
      time_series = TimeSeries.monthly(user)
      expect(time_series.days).to eq(30)
    end
  end
end
