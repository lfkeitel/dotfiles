import os
from ranger.core.loader import CommandLoader
from ranger.api.commands import Command

class empty(Command):
    """:empty

    Empties the trash directory ~/.Trash
    """

    def execute(self):
        self.fm.run("rm -rf /home/lfkeitel/.local/share/Trash/files/*")
        self.fm.run("rm -rf /home/lfkeitel/.local/share/Trash/files/.[^.]*")

class Extractor():
    def extract(self, files, cleaner=None):
        if not files:
            return

        def refresh(_):
            cwd = self.fm.get_directory(original_path)
            cwd.load_content()

        one_file = files[0]
        cwd = self.fm.thisdir
        original_path = cwd.path
        au_flags = ['-X', cwd.path]
        au_flags += self.line.split()[1:]
        au_flags += ['-e']

        if cleaner:
            cleaner(self)

        if len(files) == 1:
            descr = "extracting: " + os.path.basename(one_file.path)
        else:
            descr = "extracting files from: " + os.path.basename(one_file.dirname)

        obj = CommandLoader(args=['aunpack'] + au_flags \
                + [f.path for f in files], descr=descr)

        obj.signal_bind('after', refresh)
        self.fm.loader.add(obj)

class extracthere(Command, Extractor):
    def execute(self):
        """ Extract copied files to current directory """
        copied_files = tuple(self.fm.copy_buffer)

        def cleaner(self):
            self.fm.copy_buffer.clear()
            self.fm.cut_buffer = False

        self.extract(copied_files, cleaner)

class extractsel(Command, Extractor):
    def execute(self):
        """ Extract selected file to current directory """
        selected_files = self.fm.thistab.get_selection()

        def cleaner(self):
            self.fm.mark_files(all=True, val=False)

        self.extract(selected_files, cleaner)
