# AASS

Acts-As-State-Setter (AASS) sets the next state of a object based on the current state and a specified condition.

## Installation

Add this line to your application's Gemfile:

    gem 'aass'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aass

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

Delivery.new(status: 'unassigned').next_state
=> "postponed"
```


## After

```
class Delivery < ActiveRecord::Base
  include AASS

  aass(column: :status) do
    # higher gets priority
    set from: :unassigned, to: :assigned, if: :can_assign?
    set from: :unassigned, to: :postponed, if: :can_postpone?
    set from: :unassigned, to: :cancelled, if: :can_cancel?
    set from: :shipping, to: :unassigned, if: :can_ship?
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


Delivery.new(status: 'unassigned').next_state
=> "postponed"
```

## To-Do
1. Integration with AASM
2. Provide aass_status! to update state immediately
3. Perhaps a dynamic

## Contributing

1. Fork it ( https://github.com/kentan88/aass/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
