require_relative "../../../../base"

describe "VagrantPlugins::GuestLinux::Cap::NetworkInterfaces" do
  let(:caps) do
    VagrantPlugins::GuestLinux::Plugin
      .components
      .guest_capabilities[:linux]
  end

  let(:machine) { double("machine") }
  let(:comm) { VagrantTests::DummyCommunicator::Communicator.new(machine) }

  before do
    allow(machine).to receive(:communicate).and_return(comm)
  end

  after do
    comm.verify_expectations!
  end

  describe ".network_interfaces" do
    let(:cap){ caps.get(:network_interfaces) }

    it "sorts discovered classic interfaces" do
      expect(comm).to receive(:sudo).and_yield(:stdout, "eth1\neth2\neth0")
      result = cap.network_interfaces(machine)
      expect(result).to eq(["eth0", "eth1", "eth2"])
    end

    it "sorts discovered predictable network interfaces" do
      expect(comm).to receive(:sudo).and_yield(:stdout, "enp0s8\nenp0s3\nenp0s5")
      result = cap.network_interfaces(machine)
      expect(result).to eq(["enp0s3", "enp0s5", "enp0s8"])
    end

    it "sorts discovered classic interfaces naturally" do
      expect(comm).to receive(:sudo).and_yield(:stdout, "eth1\neth2\neth12\neth0\neth10")
      result = cap.network_interfaces(machine)
      expect(result).to eq(["eth0", "eth1", "eth2", "eth10", "eth12"])
    end

    it "sorts discovered predictable network interfaces naturally" do
      expect(comm).to receive(:sudo).and_yield(:stdout, "enp0s8\nenp0s3\nenp0s5\nenp0s10\nenp1s3")
      result = cap.network_interfaces(machine)
      expect(result).to eq(["enp0s3", "enp0s5", "enp0s8", "enp0s10", "enp1s3"])
    end
  end
end
