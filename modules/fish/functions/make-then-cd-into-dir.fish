function make-then-cd-into-dir
    set path_dir $argv[1]
    mkdir $path_dir & cd $path_dir
end

