defmodule CacheWarmer do
  import Logger, only: [debug: 1]

  def warm do
    # warming the caches
    debug("warming the cache")

    Backer.Content.list_notification_count()
    |> IO.inspect()
    |> Enum.each(fn x -> Cachex.put(:notification, "backer:#{x.backer_id}", x.unread_notif) end)

    # ...
    debug("finished warming the cache, shutting down")
  end
end
