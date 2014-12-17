# AASS

Acts-As-State-Setter (AASS) sets the next state of a object based on the current state and a specified condition.
Is it another state machine library? No. State Machine gems like AASM assumes you already know the state to call
the event which triggers the save and callbacks. AASS is like the prequel, it sets the next state.

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
      # higher has priority
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
    true
  end

  def can_ship?
    true
  end

  def notify_customer
    ...
  end

  def remove_items
    ...
  end

end

Delivery.new(status: 'unassigned').next_state!
=> #<Delivery id: nil, date: nil, status: "postponed", created_at: nil, updated_at: nil>
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
