# AASS

Acts-As-State-Setter (AASS) is a light-weight state machine library.

## Installation

Add this line to your application's Gemfile:

    gem 'aass', :git => "git@github.com:kentan88/aass.git", :branch => "master"

## Before

```
class Delivery < ActiveRecord::Base
  def set_status
    case status
      when 'unassigned'
        if can_assign?
          'assigned'
        elsif can_postponed?
          'postponed'
        else can_cancel?
          'cancelled'
        end
      when 'assigned'
        'shipping' if can_ship?
      end
  end

  def can_assign?
    false
  end

  def can_postpone?
    true
  end

  def can_cancel?
    true
  end

  def can_ship?
    true
  end
end

Delivery.new(status: 'unassigned').set_status
=> "postponed"
```

## After

```
class Delivery < ActiveRecord::Base
  include AASS

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
=> #<Delivery id: nil, date: nil, status: "unassigned", created_at: nil, updated_at: nil>
delivery.unassigned?
=> true
delivery.assigned
=> #<Delivery id: nil, date: nil, status: "assigned", created_at: nil, updated_at: nil>
delivery.assigned?
=> true
delivery.shipped?
=> false
delivery.shipped
=> #<Delivery id: nil, date: nil, status: "shipped", created_at: nil, updated_at: nil>
delivery.shipped?
=> true
delivery.next_state!
=> #<Delivery id: nil, date: nil, status: "delivered", created_at: nil, updated_at: nil>
```

## To-Do
1. Integration with AASM
2. Provide aass_status! to update state immediately

## Contributing

1. Fork it ( https://github.com/kentan88/aass/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
