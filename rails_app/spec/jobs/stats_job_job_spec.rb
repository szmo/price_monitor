require 'rails_helper'

RSpec.describe StatsJobJob, type: :job do
  before(:each) do
    StatsJobJob.class_variable_set(:@@graphite, graphite_mock)
    allow(graphite_mock).to receive(:send_raw)
  end

  let(:graphite_mock) { double :graphite_mock }

  describe '.perform_later' do
    it 'queues job' do
      ActiveJob::Base.queue_adapter = :test
      expect { StatsJobJob.perform_later }.to have_enqueued_job
    end

    it 'pushes metrics to graphite' do
      expect(graphite_mock).to receive(:send_raw).with(instance_of(Hash))
      StatsJobJob.perform_now
    end
  end
end
