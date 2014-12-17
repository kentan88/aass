require File.join(File.dirname(__FILE__), 'lib', 'aass')

class Dummy
  include AASS

  attr_accessor :status, :name

  def initialize(opts = {})
    @status = opts[:status]
    @name = opts[:name]
  end

  aass(column: :status) do
    from :unassigned do
      to :assigned, if: :can_assign?, after: :notify_customer
      to :postponed, if: :can_postpone?
      to :cancelled, if: :can_cancel?, after: :remove_items
    end

    from :assigned do
      to :shipping, if: :can_ship?
    end
  end

  def can_assign?
    false
  end

  def can_postpone?
    true
  end

  def can_cancel?
    false
  end

  def notify_customer
  end

  def remove_items
  end

end

dummy = Dummy.new(status: 'unassigned')
p dummy.next_state!
