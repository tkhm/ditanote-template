#!/bin/bash

# shellcheck disable=SC2034
BASE_DIR=$(dirname "$0")
BASE_FILE=$(basename "$0")

main() {
  [[ $1 == "html" ]] && build_html && return
  [[ $1 == "book" ]] && build_book && return
}

build_html() {
  local map_name="note.ditamap"
  local prop_name=".backstage/note.properties"
  local out_dir="out"

  echo "Start to build with ${map_name}"
  dita \
    --input="${map_name}"\
    --output="${out_dir}"\
    --format html5\
    --propertyfile="${prop_name}"
  echo "Finished in ${SECONDS} seconds, output dir is ${out_dir}."
}

build_book() {
  local map_name="note.ditamap"
  local prop_name=".backstage/note.properties"
  local out_dir="out"
  local book_readme="${out_dir}/SUMMARY.md"

  echo "Start to build with ${map_name}"
  dita \
    --input="${map_name}"\
    --output="${out_dir}"\
    --format markdown_gitbook\
    --propertyfile="${prop_name}"
  echo "Finished in ${SECONDS} seconds, output dir is ${out_dir}."

  # Required by gitbook
  cp "${book_readme}" "${out_dir}/README.md"
}

build_map() {
  local dirlist_file_path=".backstage/ditadirs.txt"
  while read -r -a line
  do
    declare local file_list=()
    while IFS='' read -r eachmd; do file_list+=("$eachmd"); done < <(ls -1 -A "${line}"/*.md)
    output_map="${line}/note.ditamap"

    echo "(Re)build ${output_map}"
    rm -f "${output_map}"
    cat ".backstage/templates/header.ditamap" >> "${output_map}"

    for each in "${file_list[@]}"
    do
      if [[ "${each##*/}" != "index.md" ]]; then
        echo '    <topicref href="'"${each##*/}"'" format="markdown" />' >> "${output_map}"
      fi
    done

    cat ".backstage/templates/footer.ditamap" >> "${output_map}"
  done < "${dirlist_file_path}"
}

# shellcheck disable=SC2128
[[ "$0" == "${BASH_SOURCE}" ]] && main "$@"
