namespace :tmp do
  task :zzzzzzzzzzzzzz do
    rm_rf Dir["tmp/letter_opener/[^.]*"], verbose: false
  end

  task zzzzzzzzz: :letter_opener
end