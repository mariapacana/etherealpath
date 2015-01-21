$('#messages_index').prepend("<%= render(partial: 'messages/newly_added', locals: { message: @message }) %>")
