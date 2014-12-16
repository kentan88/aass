require File.join(File.dirname(__FILE__), 'lib', 'aass')

class Dummy
  include Aass

  attr_accessor :status, :name

  def initialize(opts = {})
    @status = opts[:status]
    @name = opts[:name]
  end

  aass(column: :status) do
    set from: :unassigned, to: :assigned, if: :can_assign?
    set from: :unassigned, to: :postponed, if: :can_postpone?
    set from: :unassigned, to: :cancelled, if: :can_cancel?
    set from: :assigned, to: :unassigned, if: :can_unassign?
  end

  def can_assign?
    false
  end

  def can_cancel?
    false
  end

  def can_postpone?
    false
  end

end


dummy = Dummy.new(status: 'unassigned')
dummy.aass_status
p dummy.status
