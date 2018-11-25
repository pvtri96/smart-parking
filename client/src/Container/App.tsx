import {
  CssBaseline,
  AppBar,
  createStyles,
  Theme,
  Toolbar,
  Typography,
  withStyles,
  WithStyles,
  Grid
} from "@material-ui/core";
import * as React from "react";
import HelloDemo from "../Demo/Hello";

const styles = ({ spacing }: Theme) =>
  createStyles({
    root: {
      flexGrow: 1
    },
    menuButton: {
      marginLeft: -18,
      marginRight: 10
    },
    container: {
      padding: spacing.unit * 2
    }
  });

function DenseAppBar(props: Props) {
  const { classes, children } = props;
  return (
    <div className={classes.root}>
      <CssBaseline />
      <AppBar position="static">
        <Toolbar variant="dense">
          <Typography variant="h6" color="inherit">
            API demo
          </Typography>
        </Toolbar>
      </AppBar>
      <Grid container spacing={16} className={classes.container}>
        <Grid item xs={4}>
          <HelloDemo />
        </Grid>
      </Grid>
    </div>
  );
}

interface Props extends WithStyles<typeof styles> {
  children?: React.ReactNode;
}

export default withStyles(styles)(DenseAppBar);
