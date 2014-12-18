require File.join(File.dirname(__FILE__), 'lib', 'aass')

class Delivery
  include AASS
  attr_accessor :status

  def initialize(opts = {})
    @status = opts[:status]
  end

  aass(column: :status) do
    from :unassigned do
      to :assigned, if: :assignable?
      to :postponed, if: :postponable?
      to :cancelled, if: :cancelable?
    end

    from :assigned do
      to :unassigned, if: :unassignable?
      to :shipped, if: :shippable?
    end

    from :shipped do
      to :delivered, if: :deliverable?
    end
  end

  def assignable?
    false
  end

  def postponable?
    true
  end

  def cancellable?
    false
  end

  def shippable?
    true
  end

  def unassignable?
    false
  end

  def deliverable?
    true
  end
end

delivery = Delivery.new(status: 'unassigned')
p delivery.unassigned? #true
p delivery.assigned #<Delivery:0x000001018d34a0 @status="assigned", @name=nil>
p delivery.assigned? #true
p delivery.shipped? #false
p delivery.shipped #<Delivery:0x000001020efd28 @status="shipped", @name=nil>
p delivery.shipped? #true
p delivery.next_state! #<Delivery:0x0000010120b4d8 @status="delivered">
