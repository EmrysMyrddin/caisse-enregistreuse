use godot::classes::{Control, GridContainer, IGridContainer};
use godot::prelude::*;

struct CaisseEnregistreuse;

#[gdextension]
unsafe impl ExtensionLibrary for CaisseEnregistreuse {}

#[derive(GodotClass)]
#[class(base=GridContainer, init, tool)]
struct DynamicGridContainer {
    base: Base<GridContainer>,
}

#[godot_api]
impl IGridContainer for DynamicGridContainer {
    fn ready(&mut self) {
        let base = self.base();
        base.signals()
            .resized()
            .connect_other(self, Self::update_gap);
        base.signals()
            .child_entered_tree()
            .connect_other(self, Self::update_gap_on_child_update);
        base.signals()
            .child_exiting_tree()
            .connect_other(self, Self::update_gap_on_child_update);
        base.signals()
            .sort_children()
            .connect_other(self, Self::update_gap);
    }
}

impl DynamicGridContainer {
    fn update_gap(&mut self) {
        let mut base = self.base_mut();
        let mut gap = 0;

        if let Some(child) = base.get_child(0).map(|child| child.cast::<Control>()) {
            let grid_width = base.get_size().x;
            let child_width = child.get_size().x;
            let free_space = grid_width - child_width * base.get_columns() as f32;
            let gaps = base.get_columns() - 1;
            gap = free_space as i32 / gaps;
        }

        base.add_theme_constant_override("h_separation", gap);
    }

    fn update_gap_on_child_update(&mut self, _: Gd<Node>) {
        self.update_gap();
    }
}
