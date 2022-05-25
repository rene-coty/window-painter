/* widgets/difficulty-selector.vala
 *
 * Copyright 2022 Jamie Murphy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace WindowPainter {
    [GtkTemplate (ui = "/dev/jamiethalacker/window_painter/difficulty-selector.ui")]
    public class DifficultySelector : Adw.PreferencesPage {
        [GtkChild]
        private unowned Gtk.Stack stack;
        [GtkChild]
        private unowned Gtk.ListBox listbox;
        [GtkChild]
        private unowned Gtk.ListBox custom_listbox;
        [GtkChild]
        private unowned Gtk.Entry rowcol_count;
        [GtkChild]
        private unowned Gtk.Entry move_count;

        private bool is_infinite_mode = Application.settings.get_boolean ("infinite-mode");

        [GtkCallback]
        public void create_custom_board (Adw.ActionRow source) {
            if (is_infinite_mode) {
                move_count.set_visible (false);
            } else {
                move_count.set_visible (true);
            }

            stack.set_visible_child_name ("custom");
        }

        [GtkCallback]
        public void save_custom_board () {
            custom_listbox.unselect_all ();

            Application.settings.set_int ("difficulty", 3);

            var rowcol = rowcol_count.get_buffer ().get_text ();
            Application.settings.set_int ("custom-difficulty-rows-cols", int.parse(rowcol));

            if (!is_infinite_mode) {
                var moves = move_count.get_buffer ().get_text ();
                Application.settings.set_int ("custom-difficulty-moves", int.parse(moves));
            }

            Signals.get_default ().new_game ();
            Signals.get_default ().switch_stack ("gameboard");
        }

        [GtkCallback]
        public void activate_row (Adw.ActionRow source) {
            var length = 0;

            while (listbox.get_row_at_index (length) != null) {
                length++;
            }

            for (var i = 0; i < length; i++) {
                if (listbox.get_row_at_index (i) == source) {
                    Application.settings.set_int ("difficulty", i);
                    Signals.get_default ().new_game ();
                    Signals.get_default ().switch_stack ("gameboard");
                }
            }
        }

        public DifficultySelector () {
            Object ();
            stack.set_visible_child_name ("main");
        }

        construct {
            listbox.row_selected.connect (() => {
               listbox.unselect_all ();
            });
        }
    }
}

