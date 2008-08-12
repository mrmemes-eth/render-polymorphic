render :polymorphic
===================

**"Hey! Get that excess conditional logic out of that view!"**

`render :polymorphic` is a simple plugin which adds a :polymorphic parameter to the `ActionView::Base#render` method. This adds an opinionated method of  rendering a partial at a derived path.  Useful in situations where you have views that belong to polymorphic resources.

Show Rather Than Tell:
----------------------

*Examples assume these associations:*

    class Message < ActiveRecord::Base
      belongs_to :messageable, :polymorphic => true
    end
    
    class User < ActiveRecord::Base
      has_many :messages, :as => :messageable
    end
    
    class Group < ActiveRecord::Base
      has_many :messages, :as => :messageable
    end

before `render :polymorphic`

    # in app/views/messages/index.html.erb
    <%- if message.messageable.is_a?(User) %>
      # lot's of user-specific view code here
    <%- elsif messageable.messageable.is_a?(Group) %>
      # lot's of group-specific view code here
    <%- end %>

Personally, I despise huge blocks of conditional logic wrapping lots of view  code. The above could be written a bit more nicely without using 
`render :polymorphic` as such:

    # in app/views/messages/index.html.erb
    <%- if message.messageable.is_a?(User) %>
      <%= render :partial => 'user_index', :locals => { :message => message } %>
    <%- elsif messageable.messageable.is_a?(Group) %>
      <%= render :partial => 'group_index', :locals => { :message => message } %>
    <%- end %>
    
But there's an abstraction to be made there, which is precisely what 
`render :polymorphic` does:

    # in app/views/messages/index.html.erb
    <%= render :polymorphic => message.messageable, :locals => { :message => message } %>

Which will in turn render a partial at `app/views/users/messages_index.html.erb` (assuming `message.messageable` is a `User`).  And there we go, a neatly encapsulated pattern for getting excess conditional logic out of the view.