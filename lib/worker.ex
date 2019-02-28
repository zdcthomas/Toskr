defmodule Bifrost.Worker do

  def start_link(%{module: module, funk: funk} = params) do
    body = Map.drop(params, [:module, :funk])
    Task.start_link(fn -> 
      apply(module, funk, [body])
    end)
  end

end